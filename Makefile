all: test

test:
	ansible-playbook example.yml -c local -i hosts -v
