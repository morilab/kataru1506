#!/usr/bin/ruby
require 'rexml/document'
require 'open3'
require 'pp'

module STATE
    IDLE   = 0
    LINE   = 1
    TOGGLE = 2
    COMBI  = 3
    STATE  = 4
    MODULE = 10
end

module MODE
   MISS    = 0
   HIT     = 1
end

command  = "covered "
opt_hit  = "report -d v -c"
opt_miss = "report -d v   "
cdd_file = "coverage.cdd"

def parse(db,report)
    state = STATE::IDLE
    mode  = MODE::MISS
    name  = ""
    db = Hash.new if db.nil?
    report.each{ |line|
        case state
        when STATE::IDLE then
            if line=~/LINE COVERAGE RESULTS/ then
                state = STATE::LINE
            elsif line=~/TOGGLE COVERAGE RESULTS/ then
                state = STATE::TOGGLE
            elsif line=~/COMBINATIONAL LOGIC COVERAGE RESULTS/ then
                state = STATE::COMBI
            elsif line=~/FINITE STATE MACHINE COVERAGE RESULTS/ then
                state = STATE::STATE
            end
        when STATE::LINE then
            case line
            when /Missed Lines/ then
                mode = MODE::MISS
            when /Hit Lines/ then
                mode = MODE::HIT
            when /Module: (\w+), File: ([\w\.\/]+)/ then
                name = $1
                db[name] = Hash.new unless db.has_key?(name)
                db[name]["file"] = $2
                db[name][MODE::HIT]  = Array.new if db[name][MODE::HIT].nil?
                db[name][MODE::MISS] = Array.new if db[name][MODE::MISS].nil?
            when /^\s+(\d+):\s/ then
                db[name][mode].push($1)
            end
        end
    }
    return db
end

# カバレッジ結果の収集
out,err,st = Open3.capture3([command,opt_hit ,cdd_file].join(" "))
db = parse(db ,out.split("\n"))
out,err,st = Open3.capture3([command,opt_miss,cdd_file].join(" "))
db = parse(db ,out.split("\n"))

db.each{ |k,v|
    printf("%s Hit=%d Miss=%d\n",k,v[MODE::HIT].length ,v[MODE::MISS].length)
}

# XMLの出力
doc = REXML::Document.new
doc << REXML::XMLDecl.new('1.0','UTF-8')
coverage = doc.add_element("coverage",{"ccn"=>"0.0","version"=>"0.1"})
sources  = coverage.add_element("sources")
source   = sources.add_element("source").add_text("./verification/sim/")
packages = coverage.add_element("packages")
package  = packages.add_element("package",{"name"=>"project name"})

classes   = package.add_element("classes")
db.each{ |k,v|
    clas     = classes.add_element("class",{"name"=>k ,"filename"=>v["file"]})
    #methods  = clas.add_element("methods")
    #method   = methods.add_element("method",{"name"=>k ,"signature"=>"#()V"})
    lines    = clas.add_element("lines")
    v[MODE::HIT ].each{ |num| line = lines.add_element("line",{"number"=>num,"hits"=>"1"})}
    v[MODE::MISS].each{ |num| line = lines.add_element("line",{"number"=>num,"hits"=>"0"})}
}

fmt = REXML::Formatters::Pretty.new
fmt.write(doc.root,STDOUT)
