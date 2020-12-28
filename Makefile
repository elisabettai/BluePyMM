all: install
install: clean
	python -c "exec(\"import sys, pip\\nif map(int, pip.__version__.split('.')) <= [9, 0, 0]: sys.exit('Need pip version >= 9, please upgrade pip in your python environment')\")"
	python setup.py sdist
	pip install `ls dist/bluepymm-*.tar.gz` --upgrade
test: install_tox
	tox
test2: install_tox
	tox -e py27-unit-functional
test3: install_tox
	tox -e py3-unit-functional
unit2: install_tox
	tox -e py27-unit
unit3: install_tox
	tox -e py3-unit
func2: install_tox
	tox -e py27-functional
func3: install_tox
	tox -e py3-functional
install_tox:
	pip install tox
tox_clean:
	rm -rf .tox
clean:
	rm -rf bluepymm.egg-info
	rm -rf dist
	find . -name '*.pyc' -delete
	rm -rf bluepymm/tests/examples/simple1/tmp
	rm -rf bluepymm/tests/examples/simple1/tmp_git
	rm -rf bluepymm/tests/examples/simple1/output
	rm -rf bluepymm/tests/examples/simple1/output_megate
	rm -rf bluepymm/tests/examples/simple1/hoc
	rm -rf bluepymm/tests/tmp
	rm -rf docs/build
	rm -rf build
	rm -rf .coverage
	rm -rf cov_reports

	mkdir bluepymm/tests/tmp

simple1_git:
	cd bluepymm/tests/examples/simple1; python build_git.py
autopep8: clean
	 pip install autopep8
	 find bluepymm -name '*.py' -exec autopep8 -i '{}' \;
doc:
	 pip install -q sphinx sphinx-autobuild sphinx_rtd_theme -I
	 sphinx-apidoc -o docs/source bluepymm
	 cd docs; $(MAKE) clean; $(MAKE) html
docpdf:
	 pip install sphinx sphinx-autobuild -I
	 cd docs; $(MAKE) clean; $(MAKE) latexpdf
docopen: doc
	open docs/build/html/index.html
toxbinlinks:
	cd ${TOX_ENVBINDIR}; find $(TOX_NRNBINDIR) -type f -exec ln -sf \{\} . \;
