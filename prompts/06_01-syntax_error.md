When executing:

```bash
bash build.sh --phase app
```

I got the following error as part of the middleman execution.

/usr/local/share/gems/gems/tilt-2.7.0/lib/tilt/template.rb:472:in 'Module#class_eval': partial/_footer.erb:2: syntax errors found (SyntaxError)
  0 | 
  1 | begin; __original_outvar = @_out_buf; @_out_buf = ::String.new; @_out_buf << '<footer>
> 2 | ...  ).to_s; @_out_buf << '
'.freeze; @_out ...
    |     ^ expected a block beginning with `do` to end with `end`
    |      ^ unexpected ')', assuming it is closing the parent parentheses
    |             ^ expected a block beginning with `do` to end with `end`
    |             ^ expected an `end` to close the `def` statement
    |             ^ expected an `end` to close the `begin` statement