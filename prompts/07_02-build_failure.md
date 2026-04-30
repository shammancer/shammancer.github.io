When executing:

```bash
bash build.sh --phase app
```

I got the following error as part of the middleman execution.

```
/usr/local/share/gems/gems/middleman-core-4.6.3/lib/middleman-core/util/data.rb:60:in 'Regexp#match': invalid byte sequence in US-ASCII (ArgumentError)

        match = build_regex(frontmatter_delims).match(content) || {}
                                                      ^^^^^^^
        from /usr/local/share/gems/gems/middleman-core-4.6.3/lib/middleman-core/util/data.rb:60:in 'Middleman::Util::Data.parse'
```

How do I correct it?