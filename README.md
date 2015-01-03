# Wercker Step Hugo Build

[![wercker status](https://app.wercker.com/status/837cf1a5869eb00da38dbd6083e35825/m "wercker status")](https://app.wercker.com/project/bykey/837cf1a5869eb00da38dbd6083e35825)

This step will download the specified version of [Hugo](http://gohugo.io) and run this over the source code to generate the static version of your site. This can then automatically be deployed using other steps.

# Parameters

## version (optional/recommended)

Specifies the version of Hugo to be used, by default this is `0.12`. It is recommended to set this, so you don't accidentally build you site with a version it isn't ready for.

## theme (optional)

Specifies the theme to be used for the generation of the site. When this isn't defined no theme will be used.

## flags (optional)

Apart from the theme, other flags can be provided as a single string. These flags will be provided exactly as set.

# Example wercker.yml

```yml
box: wercker/default
build:
  steps:
    - arjen/hugo-build:
        version: 0.12
        theme: redlounge
        flags: --disableSitemap=true
```
