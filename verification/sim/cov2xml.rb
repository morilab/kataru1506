#!/usr/bin/ruby
require 'rexml/document'

doc = REXML::Document.new
doc << REXML::XMLDecl.new('1.0','UTF-8')

coverage = doc.add_element("coverage",{"ccn"=>"0.0","version"=>"0.1"})
sources  = coverage.add_element("sources")
source   = sources.add_element("source").add_text(".")
package  = coverage.add_element("package",{"name"=>"Pj1234"})
classes  = package.add_element("classes")
class1   = classes.add_element("class",{"name"=>"tb_top.u0","filename"=>"rtl/ram.v"})
methods  = class1.add_element("methods")
method   = methods.add_element("method",{"name"=>"fifo","signature"=>"#()V","line-rate"=>"0.3","branch-rate"=>"0.7"})
lines    = method.add_element("lines")
line1    = lines.add_element("line",{"number"=>"3","hits"=>"0","branch"=>"false"})
line2    = lines.add_element("line",{"number"=>"5","hits"=>"1","branch"=>"true"})


fmt = REXML::Formatters::Pretty.new
fmt.write(doc.root,STDOUT)

# doc.write STDOUT
