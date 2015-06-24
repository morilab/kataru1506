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

module TYPE
    LINE   = 0
    TOGGLE = 1
    COMBI  = 2
    STATE  = 3
    RACE   = 4
    ASSERT = 5
    MEMORY = 6
end

command  = "covered "
opt_hit  = "report -d v -m lc -c"
opt_miss = "report -d v -m lc   "
cdd_file = "coverage.cdd"

def parse(db,report)
    state    = STATE::IDLE
    mode     = MODE::MISS
    name     = ""
    line_num = 0
    db = Hash.new if db.nil?
    report.each{ |line|
        case state
        when STATE::IDLE then
            name = ""
            case line
            when /LINE COVERAGE RESULTS/ then
                state = STATE::LINE
            when /TOGGLE COVERAGE RESULTS/ then
                state = STATE::TOGGLE
            when /COMBINATIONAL LOGIC COVERAGE RESULTS/ then
                state = STATE::COMBI
            when /FINITE STATE MACHINE COVERAGE RESULTS/ then
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
                db[name]             = Hash.new unless db.has_key?(name)
                db[name][TYPE::LINE] = Hash.new unless db.has_key?(TYPE::LINE)
                db[name][TYPE::LINE]["file"] = $2
                db[name][TYPE::LINE][MODE::HIT]  = Array.new if db[name][TYPE::LINE][MODE::HIT].nil?
                db[name][TYPE::LINE][MODE::MISS] = Array.new if db[name][TYPE::LINE][MODE::MISS].nil?
            when /^\s+(\d+):\s/ then # 行数
                line_num = $1
                db[name][TYPE::LINE][mode].push(line_num)
            when /^~+$/ then
                state = STATE::IDLE unless name==""
            end
        when STATE::COMBI then
            case line
            when /Missed Combinations/ then
                mode = MODE::MISS
            when /Hit Combinations/ then
                mode = MODE::HIT
            when /Module: (\w+), File: ([\w\.\/]+)/ then
                name = $1
                db[name]              = Hash.new unless db.has_key?(name)
                db[name][TYPE::COMBI] = Hash.new unless db.has_key?(TYPE::COMBI)
                db[name][TYPE::COMBI]["file"] = $2
                db[name][TYPE::COMBI][MODE::HIT]  = Hash.new if db[name][TYPE::COMBI][MODE::HIT].nil?
                db[name][TYPE::COMBI][MODE::MISS] = Hash.new if db[name][TYPE::COMBI][MODE::MISS].nil?
            when /^\s+(\d+):\s/ then # 行数
                line_num = $1
                db[name][TYPE::COMBI][MODE::HIT ][line_num]=Hash.new if db[name][TYPE::COMBI][MODE::HIT ][line_num].nil?
                db[name][TYPE::COMBI][MODE::MISS][line_num]=Hash.new if db[name][TYPE::COMBI][MODE::MISS][line_num].nil?
                if mode==MODE::HIT then
                    db[name][TYPE::COMBI][MODE::HIT][line_num][0] = 1 # 嘘っぽい
                end
            when /^\s+Expression (\d+)\s+\((\d+)\/(\d+)\)/ # カバレッジ
                exp_num = $1
                pt      = $2.to_i
                pt_all  = $3.to_i
                if mode==MODE::MISS then
                    db[name][TYPE::COMBI][MODE::MISS][line_num][exp_num] = pt_all-pt
                    db[name][TYPE::COMBI][MODE::HIT ][line_num][exp_num] = pt
                end
            when /^~+$/ then
                state = STATE::IDLE unless name==""
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
    v[TYPE::LINE][MODE::MISS].each{ |num| line = lines.add_element("line",{"number"=>num,"hits"=>"0","branch"=>"false"})}
    v[TYPE::LINE][MODE::HIT ].each{ |num|
        if v[TYPE::COMBI][MODE::MISS].has_key?(num) then
            line = lines.add_element("line",{"number"=>num,"hits"=>"1","branch"=>"true","condition-coverage"=>"0% (0/2)"})
            conditions = line.add_element("conditions")
            v[TYPE::COMBI][MODE::MISS][num].each{ |exp_num,exp_cnt|
                miss = exp_cnt.to_i
                hit = v[TYPE::COMBI][MODE::HIT][num][exp_num].to_i
                condition = conditions.add_element("condition",{"number"=>exp_num,"type"=>"jump","coverage"=>sprintf("%f%",hit/(hit+miss).to_f*100)})
            #   condition = conditions.add_element("condition",{"number"=>exp_num,"type"=>"jump","coverage"=>sprintf("%d/%d",hit,(hit+miss))})
            }
        else
            line = lines.add_element("line",{"number"=>num,"hits"=>"1","branch"=>"false"})
        end
    }
}

fmt = REXML::Formatters::Pretty.new
fmt.write(doc.root,STDOUT)
