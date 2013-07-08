# Vagrant Box Version Plugin

This plugin allows users of vagrant boxes to check they have the latest
available version. It's designed to do so in the simplest way possible.

It provides two things:

1. A convention for storing version information inside vagrant boxes
2. A plugin that checks that the version available on a remote server is the
	 same as the current box version.

Versions are stored inside the box in `include/version` and just contain a
version identifier. The part of that version number before the first dash is
parsed as an integer for comparison. We use 
`[jenkins build number]-[git short revision]`.

The purpose of this plugin is to enable organizations to continuously improve
their vagrant-backed dev environments, and treat them as disposable (á la
[Chad Fowler][fowler])

## Usage

### For box publishers

Boxes should include a file called `version` containing your version of the
box. Simply create the file with the desired content and include it in your
packaged box when you run:

    vagrant package --include version

The plugin requires a file with the name `[box-name].box.version` to be
installed in a known HTTP/HTTPS/FTP location. We upload them alongside the box
with the same jenkins job that builds boxes.

### For box users

Once the plugin is installed (`vagrant plugin install vagrant_box_version`),
simply add the location of your box server's version files to your config,
e.g.

    config.version.url = http://my-vagrant-box.es/

You can then run `vagrant version` to check you have the latest version. If
you don't or either remote or local version can't be determined, you will be
warned about it.

From version 0.0.2, you can simply run `vagrant up`, `vagrant provision` or
`vagrant reload` and the version checking will be triggered.

### Installation from source.

Simply run `rake build`, and then
`vagrant plugin install pkg/vagrant_box_version`.

### Extension points

This is always going to be minimal. However in the future it might:

* Allow a regex-based version format that identifies points of comparison.
* Offer to update your box for you (destroying the current box)
* Provide more flexibility about version information source (frankly unlikely)

## Contributing

Contributions in the form of pull requests are are very welcome, though anyone
wanting to produce a full box package manager might want to start again.

[fowler]: http://chadfowler.com/blog/2013/06/23/immutable-deployments/
