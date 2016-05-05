# Wercker Step Hugo Build

[![wercker status](https://app.wercker.com/status/837cf1a5869eb00da38dbd6083e35825/m "wercker status")](https://app.wercker.com/project/bykey/837cf1a5869eb00da38dbd6083e35825)

This step will download the specified version of [Hugo](http://gohugo.io) and run this over the source code to generate the static version of your site. This can then automatically be deployed using other steps.

Since version 1.9.0, the step has the latest two versions of Hugo already installed thereby skipping the download part of the step.

# Tutorial

If you are new to Wercker, there is a full tutorial on how to use this step in combination with an automatic deployment step in the [Hugo documentation](http://gohugo.io/tutorials/automated-deployments/).

# Requirements

This step does not require any specific Wercker box or container, and should work on both the classic and Docker versions.

# Parameters

## version (optional/recommended)

Specifies the version of Hugo to be used, by default this is `"0.15"`. It is recommended to set this, so you don't accidentally build you site with a version it isn't ready for. Due to Wercker not being able to properly handle `0.x` version numbers, you will need to put quotes around the version number.

Note that you don't have to provide a version if you already have Hugo installed. If you wish to install a specific version regardless of what is running on your container, you can override this using the `force_install` parameter.

### HEAD support

New in version 1.8 is support for the `HEAD` version. This will pull in the latest version from GitHub and compile it. This requires you to provide the version as below. Take note that this means using a version of Hugo that is not released and might be unstable, so use this at your own risk.

```yml
box: debian
build:
  steps:
    - arjen/hugo-build:
        version: "HEAD"
```


## theme (optional)

Specifies the theme to be used for the generation of the site. When this isn't defined no theme will be used.

## config (optional)

If you wish to use a different config file than the default `config.toml|yaml|json` you can provide the relative path and name of this file here.

## flags (optional)

Apart from the theme and config file, other flags can be provided as a single string. These flags will be provided exactly as set.

## force_install (optional)

If you already have Hugo installed in your container, this step will use the installed version. To override this behaviour, set `force_install` to `true`.

## disable_pygments (optional)

If you don't need [support for pygments](http://gohugo.io/extras/highlighting/), you can speed up the build process by not installing it. Set `disable_pygments` to `true` to disable support for pygments.

## dev_flags, prod_branches and dev_branches (optional)

These 3 optional parameters allow you to use different build flags for production and development branches. This setting will **override** the `config`, `flags` and `theme` parameters in builds on your development branches.

### How does it work?

First, set `dev_flags` to the flags you would like to use for your development branches. Your production branches will still use `config`, `flags` and `theme`.

Next, set **either** `prod_branches` or `dev_branches`.

`prod_branches` should contain a space delimited list of branches that you would like to mark as *production* branches.

`dev_branches` should contain a space delimited list of branches that you would like to mark as *development* branches.

E.g. with [git flow](http://nvie.com/posts/a-successful-git-branching-model/):

```yml
box: debian
build:
  steps:
    - arjen/hugo-build:
        version: "0.15"
        theme: redlounge
        config: my-production-config.toml
        dev_flags: -D -F
        prod_branches: master
```

# Example wercker.yml (Docker)

```yml
box: debian
build:
  steps:
    - arjen/hugo-build:
        version: "0.15"
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
        version: "0.15"
        theme: redlounge
        config: second-config.toml
        flags: --disableSitemap=true
```
