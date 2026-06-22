When executing:

```bash
bash build.sh --phase app
```

I got the following error as part of the middleman execution.

undefined local variable or method 'local_assigns' for #<#<Class:0x00007ff41093d3f0>:0x00007ff4107261c0>
partial/_card.erb:2:in 'Tilt::CompiledTemplates#__tilt_4736'
/usr/local/share/gems/gems/tilt-2.7.0/lib/tilt/template.rb:394:in 'UnboundMethod#bind_call'
/usr/local/share/gems/gems/tilt-2.7.0/lib/tilt/template.rb:394:in 'Tilt::Template#evaluate_method'
/usr/local/share/gems/gems/tilt-2.7.0/lib/tilt/template.rb:266:in 'Tilt::Template#evaluate'
/usr/local/share/gems/gems/tilt-2.7.0/lib/tilt/template.rb:134:in 'Tilt::Template#render'