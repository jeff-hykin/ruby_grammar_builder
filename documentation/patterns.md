Here are some pre-made patterns you can use instead of having to write the regex for them.

```ruby
@space
@spaces
@digit
@digits
@standard_character
@word
@word_boundary
@white_space_start_boundary
@white_space_end_boundary
@start_of_document
@end_of_document
@start_of_line
@end_of_line
```

For example
```ruby
smalltalk = Pattern.new(
    match: Pattern.new(/blah/).then(@spaces).then(/blah/).then(@spaces).then(/blah/),
    tag_as: "string.smalltalk",
)
```