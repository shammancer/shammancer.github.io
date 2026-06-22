When executing:

```bash
bash build.sh --phase app
```

I got the following error as part of the middleman execution.

```
undefined method 'index' for an instance of Middleman::CoreExtensions::Data::DataStore
/usr/local/share/gems/gems/middleman-core-4.6.3/lib/middleman-core/core_extensions/data.rb:180:in 'Middleman::CoreExtensions::Data::DataStore#method_missing'
partial/_header.erb:12:in 'Tilt::CompiledTemplates#__tilt_4736'
/usr/local/share/gems/gems/tilt-2.7.0/lib/tilt/template.rb:394:in 'UnboundMethod#bind_call'
/usr/local/share/gems/gems/tilt-2.7.0/lib/tilt/template.rb:394:in 'Tilt::Template#evaluate_method'
/usr/local/share/gems/gems/tilt-2.7.0/lib/tilt/template.rb:266:in 'Tilt::Template#evaluate'
/usr/local/share/gems/gems/tilt-2.7.0/lib/tilt/template.rb:134:in 'Tilt::Template#render'
```

How do I correct it?