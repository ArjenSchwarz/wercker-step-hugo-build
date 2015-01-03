# Wercker Step Hugo Build

This step will download the specified version of [Hugo](http://gohugo.io) and run this over the source code.

# Parameters

## version (optional)

Specifies the version of Hugo to be used, by default this is `0.12`.

## theme (optional)

Specifies the theme to be used for the generation of the site. When this isn't defined no theme will be used.

## flags (optional)

Apart from the theme, other flags can be provided as a single string. These flags will be provided exactly as set.

# Example wercker.yml

```yml
build:
  steps:
    - arjenschwarz/hugo-build:
        version: 0.12
        theme: herring-cove
        flags: --buildFuture=true
```
