# Wercker Step Hugo Build

[![wercker status](https://app.wercker.com/status/837cf1a5869eb00da38dbd6083e35825/m "wercker status")](https://app.wercker.com/project/bykey/837cf1a5869eb00da38dbd6083e35825)

This step will download the specified version of [Hugo](http://gohugo.io) and run this over the source code to generate the static version of your site. This can then automatically be deployed using other steps.

# Tutorial

If you are new to Wercker, there is a full tutorial on how to use this step in combination with an automatic deployment step in the [Hugo documentation](http://gohugo.io/tutorials/automated-deployments/).

# Requirements

This step does not require any specific wercker box, and should work on any box.

# Parameters

## version (optional/recommended)

Specifies the version of Hugo to be used, by default this is `"0.14"`. It is recommended to set this, so you don't accidentally build you site with a version it isn't ready for. Due to Wercker not being able to properly handle `0.x` version numbers, you will need to put quotes around the version number.

Note that you don't have to provide this if you already have hugo installed. You can override this using the `force_install` parameter.

## theme (optional)

Specifies the theme to be used for the generation of the site. When this isn't defined no theme will be used.

## config (optional)

If you wish to use a different config file than the default `config.toml|yaml|json` you can provide the relative path and name of this file here.

## flags (optional)

Apart from the theme and config file, other flags can be provided as a single string. These flags will be provided exactly as set.

## force_install (optional)

If you already have hugo installed in your container, this step will use the installed version. To override this behaviour, set `force_install` to `true`.

# Example wercker.yml (Docker)

```yml
box: debian
build:
  steps:
    - arjen/hugo-build:
        version: "0.14"
        theme: redlounge
        config: second-config.toml
        flags: --disableSitemap=true
```

# Example wercker.yml (Classic)

```yml
box: wercker/default
build:
  steps:
    - arjen/hugo-build:
        version: "0.14"
        theme: redlounge
        config: second-config.toml
        flags: --disableSitemap=true
```
