#!/usr/bin/ruby
require 'rexml/document'

fp = File.open("coverage.rpt","r")

doc = REXML::Document.new
doc << REXML::XMLDecl.new('1.0','UTF-8')

coverage = doc.add_element("coverage",{"ccn"=>"0.0","version"=>"0.1"})
sources  = coverage.add_element("sources")
source   = sources.add_element("source").add_text("./verification/sim/")
package  = coverage.add_element("package",{"name"=>"Pj1234"})

module STATE
    IDLE   = 0
    LINE   = 1
    TOGGLE = 2
    COMBI  = 3
    STATE  = 4
    MODULE = 10
end

state = STATE::IDLE
mod_name = "(null)"
filepath = "./verification/sim/"
fp.each{ |line|
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
        if line=~/Module: (\w+), File: ([\w\.\/]+)/ then
            mod_name = $1
            filepath = $2
            @classes  = package.add_element("classes")
            @class1   = @classes.add_element("class",{"name"=>mod_name,"filename"=>filepath})
            @methods  = @class1.add_element("methods")
            @method   = @methods.add_element("method",{"name"=>mod_name,"signature"=>"#()V","line-rate"=>"0.3","branch-rate"=>"0.7"})
            @lines    = @method.add_element("lines")
        elsif line=~/^\s+(\d+):\s/ then
            line      = @lines.add_element("line",{"number"=>$1,"hits"=>"0","branch"=>"false"})
        end
    end
}

fmt = REXML::Formatters::Pretty.new
fmt.write(doc.root,STDOUT)

# doc.write STDOUT
