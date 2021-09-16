# What is this?

This is a library for making textmate grammars in a maintainable way. It has been the backbone of the [Better C++ Syntax extension](https://marketplace.visualstudio.com/items?itemName=jeff-hykin.better-cpp-syntax) and the beta version of this library is the backbone of Better Docker syntax, the Better Perl syntax, and the Better Shell syntax.

# What makes it more maintainable?

- **The full power of a programming language**
  - The first problem is grammars themselves are static. No variables, no functions, which means code duplication is rampant. The most basic feature of this library is providing you with a full/legit programming language (ruby) to develop grammars with.
  - Why ruby? Textmate regex is based on Ruby regex. (But also there are 100 other reasons ruby is perfect for this library)
- **Truly modular patterns**
  - This was so much work to implement
  - By default patterns effectively couldn't be modular/composable because the only way to give a pattern a name is to give it a number (a capture group number). But when you take `PatternAAA` and put it inside `PatternBBB`, the numbers change because they're sequential and `PatternBBB` has some groups of its own that offset all the group numbers in `PatternAAA`. This library solves this problem, by doing all the heavy lifting of calculating/tracking what the capture numbers will be offset by in order to correctly attach the syntax-names to the correct number. You never have to deal with capture group numbers again.
- **No more double escaping regex**
  - Textmate uses regex, which has its own escape patterns.<br>But grammars are written in JSON/XML/tmLanguage formats which have a different set of escape patterns.<br>Double escaping regex inside a JSON string is an absolute nightmare
  - This library fixes that because ruby has regex-literals, and also string literals (also called raw strings). So you can finally just write what you mean (and you'll actually have syntax highlighting!)
- **Regex has a more-readble option**
  - instead of `/(?<=thing)otherThing/` you can write `lookBehindFor(/thing/).then(/otherThing/)`
  - instead of `/(a|b)/` you can write `Pattern.new(/a/).or(/b/)`
  - instead of `/a?/` you can write `maybe(/a/)`
  - etc
  - see [here](https://github.com/jeff-hykin/better-cpp-syntax/blob/fe873cdfacd1df7072e7b8c95df3df369c1ffcaa/documentation/CONTRIBUTING.md#L124) for some more examples
  - readable regex has a LOT of support, including advanced tools like [backreferences](https://www.regular-expressions.info/backref.html) and [atomic capture groups](https://www.regular-expressions.info/atomic.html). Sadly we haven't had time to document all of the features yet.

### Does this make it better than Tree-sitter parsers?

NO.
- The Tree Sitter is vastly -- categorically -- superior in parsing capability, runtime efficiency, maintainability, and expressiveness-of-output. Sadly some editors only support textmate though and this tool is for them.

# How do I use this?

Here's a quick run down.

(just FYI, we would like to have a bunch more documentation, but it takes time)

`gem install ruby_grammar_builder`

```ruby
require "ruby_grammar_builder"

# create a new grammar
grammar = Grammar.new(
    name: "C++",
    scope_name: "source.cpp",
    fileTypes: [
        "cc",
        "cpp",
        "cp",
        "cxx",
        "c++",
        "C",
        "h",
        "hh",
        "hpp",
        "h++"
    ],
    version: "",
    information_for_contributors: [
        "This json file was auto generated by a much-more-readable ruby file",
	"(e.g. don't edit it directly)",
    ],
)

# create a pattern for a keyword
grammar[:misc_keyword] = Pattern.new(
    match: /\bmisc\b/,
    tag_as: "keyword.other.misc",
    # note: don't try matching newlines because Patterns cant match more than one line
    # (this is NOT a library limitation, but a limitation of the Textmate engines that code editors use)
    
    # below is both documentation e.g. "hey this is what the pattern should/shouldnt do"
    # but it is also a unit test that actually makes sure those things are true
    should_fully_match: [ "misc" ],
    should_partial_match: [ "misc.", "= misc", ],
    should_not_partial_match: [ "miscc", "Misc", "_misc" ],
)

# create a pattern-range for something like string quotes
grammar[:string] = PatternRange.new(
    tag_as: "string.quoted.double",
    start_pattern: Pattern.new(
        match: /"/,
        tag_as: 'punctuation.definition.string'
    ),
    end_pattern: Pattern.new(
        match: /"/,
        tag_as: 'punctuation.definition.string'
    ),
    includes: [
        # escape pattern
        Pattern.new(
            match: /\\./,
            tag_as: "constant.character.escape",
        ),
    ],
)


# 
# add them to "top level"
# 
grammar[:$initial_context] = [
    :misc_keyword, # <- first tries to find keyword
    :string,       # <- if that fails, it tries to find a string pattern
]


# 
# export to a file
# 
grammar.save_to(
    syntax_name: "demo_syntax",
    syntax_dir: "./syntaxes",
    tag_dir: "./demo_syntax",
)
```

#### Here's an example of modular patterns:

```ruby
quote = Pattern.new(
    match: /"/,
    tag_as: "quote",
)

smalltalk = Pattern.new(
    match: /blah\/blah\/blah/,
    tag_as: "string.smalltalk",
)

phrase = Pattern.new(
    match: Pattern.new(/the man said: /).then(quote).then(smalltalk).then(quote),
    tag_as: "other.phrase",
)

# NOTE: PatternRanges currently can't be put inside of Patterns. The textmate engine doesn't support this, and we have not found a good enough workaround yet
```

## What Names should I use for `tag_as:`?

This is very important. Please try to follow the newly created standard documented [here](https://github.com/chbk/flight-manual.atom.io/blob/scopes/content/hacking-atom/sections/syntax-naming-conventions.md). Previously there was no standard whatsoever and it made making themes very hard.

### API Details

- There is a bit more more documentation [here](https://github.com/jeff-hykin/better-cpp-syntax/blob/fe873cdfacd1df7072e7b8c95df3df369c1ffcaa/documentation/CONTRIBUTING.md#L1)
- The current best way to understand the features are by reading that documentation, and then searching for examples within [this project](https://github.com/jeff-hykin/better-cpp-syntax/)


### Using the generated grammar

If you want to use the grammar inside VS Code
 - watch a quick tutorial on how to publish a VS Code extension
 - And here is [an example](https://github.com/jeff-hykin/better-cpp-syntax/blob/fe873cdfacd1df7072e7b8c95df3df369c1ffcaa/package.json#L35) of what needs to be inside the package.json when publishing the output from this library



# Setup for Contributing to the library

Everything is detailed in the `documentation/setup.md`!
