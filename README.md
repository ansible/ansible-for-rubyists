ansible-for-rubyists
====================

Ansible is written in Python, but you can write modules in any language.  Here are some Ruby examples to get you started!

Documentation
=============

If you would like to read more about ansible, visit [http://ansible.com/docs/](http://ansible.com/docs).

The docs will help you understand how to use Ansible better, and about it's data-driven configuration language, which
is YAML based.

This repo is all about how to write Ansible modules in Ruby, rather than Python, and to show how easy that can be.

Requirements
============

These examples assume Ansible 1.2 or later, and were developed using Ruby 1.8.7.  Most any Ruby
interpreter should be fine.

The Ruby interpreter is for the remote machine, no Ruby interpreter at all is required on the local box.

Note: If you need to set the path of the Ruby interpreter explicitly, setting an inventory variable in ansible
called ansible_ruby_interpreter can allow you to pick something that isn't in the system path, which is
quite handy, as you may have some systems that have Ruby in different locations, and users may have already
configured their paths to pick something weird.  Resist the urge to use /usr/bin/env in your shebang
lines if you want to take advantage of this variable, as it is a great way to deal with problems if you have
a different Ruby in different places on different hosts.

With that out of the way, let's get going.

Structure
=========

In this checkout, you will see a very trivial playbook and a local 'library' directory.  The local modules
directory is Ansible's way to make it trivial to distribute modules with a playbook.

If you are looking for ways to distribute pieces of playbooks, these are called 'roles', in Ansible.  Modules are pieces of transferable utility code that make the playbook actually be able to do things on managed systems.  These are covered
in the Ansible documentation.

To fire off the super trivial example, just run "make test" and you can look at the Makefile to see the ansible
parameters passed to it.   It should be self explanatory, particularly after you learn more about how to use
Ansible as an end user.  (Maybe you know this already).

Both a facts module and a custom utility module are demoed, showing how you can use custom facts to select a group
of systems where a certain criteria is true and then do things to those systems, all using native Ruby modules,
run by Ansible.

Facts Modules and Regular Modules
=================================

The ./library/my_facts module is an example fact module written in Ruby.  If you happen to have existing facts
written for ohai and facter you want to use, you don't even need to do this, as Ansible's normal setup setup will run call
those automatically.

Note that at least facter requires you have the JSON ruby gem installed, and it's not always installed by default.  The
example playbook uses Ansible's built in gem module to install it for you, though you may wish to change this step.

The only difference in Ansible between a fact module and a regular module is a fact module is expected to return an 'ansible_facts' JSON subkey, whose values are a hash/dictionary of variable names.  These structures may be nested arbitrarily, but really any
module can return facts.

The example Ruby utility module, like the fact module, simply reads an input file specified as the first argument to
the program as JSON, and outputs JSON.

Conventions of JSON output
==========================

Ansible modules return data by printing JSON to standard output.

Returning "failed: True" is the way to signal a failure to ansible.  When something fails, always return
a "msg" attribute in the JSON that explains the failure.

Returning "changed: True" indicates something has changed.

As already mentioned, returning a dictionary key in the JSON called "ansible_facts" tells ansible to store some variables and make
them available for later use.  Again, any module can do this, and then those things are available to Ansible for use as variables
later on down in the playbook, or in templates.

Take a look at the code in the repository and you will see all of this in play, as simple as possible, and can use
this to get started writing your own modules in Ruby.

Testing modules
===============

Ansible works on remote systems by transferring your ruby module and an arguments file, and then running the program
with the path to the arguments file.  If you are debugging a failure, it is often easiest to run things on your local
system so you can set breakpoints and so on, rather than running it through all of ansible.

A sometimes easy way to test an Ansible module outside of the context of ansible is the ./hacking/test-module script in the
Ansible git repo:

    ./hacking/test-module -m ansible-for-rubyists/modules/my_calculator -a "a=2 b=3"

Or you can just test your module straight with Ruby, like so:

    ruby ./modules/my_calculator /path/to/test.json

The 'hacking' script is just a shortcut to making the JSON file.

Test.json could contain something like::

    {
        "a" : 2,
        "b" : 3
    }

In either event, you should see JSON output when you run your program, and it should be free from errors.

Potentional Ansible-core Contributor note:
==========================================

Just as a sidenote, modules to be distributed in Ansible core still do need to be Python.  We do this because it would
be too confusing to have a mix of 5 or 6 different languages in the core and a lot of us are Python developers.

However, we do encourage people to write modules in whatever language you feel like.

Modules in core should look at other modules in core to take advantage
of common library code support.

We do encourage you to write your own modules, put them on github, and share them, regardless of what langauge you
care to write them in, and we are happy to link to lots of these on the "contrib" pages of the documentation.

Thanks and have fun!

