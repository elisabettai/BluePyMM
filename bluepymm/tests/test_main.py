"""Test bluepymm/main"""

# Copyright BBP/EPFL 2017; All rights reserved.
# Do not distribute without further notice.

import os
import shutil

from nose.plugins.attrib import attr
import nose.tools as nt

from bluepymm import main, tools


def _clear_prepare_combos_output():
    for unwanted in ['tmp', 'output']:
        if os.path.exists(unwanted):
            shutil.rmtree(unwanted)


def _verify_prepare_combos_output(scores_db, emodels_hoc_dir):
    # TODO: test database contents
    nt.assert_true(os.path.isfile(scores_db))

    nt.assert_true(os.path.isdir(emodels_hoc_dir))
    hoc_files = os.listdir(emodels_hoc_dir)
    nt.assert_equal(len(hoc_files), 2)
    for hoc_file in hoc_files:
        nt.assert_equal(hoc_file[-4:], '.hoc')


# TODO: how to test message to standard output?
@attr('unit')
def test_main_unknown_command():
    args_list = ['anything']
    main(args_list)


def test_prepare_combos():
    test_dir = 'examples/simple1'
    test_config = 'simple1_conf.json'

    with tools.cd(test_dir):
        # Make sure the output directories are clean
        _clear_prepare_combos_output()

        # Run combination preparation
        args_list = ['prepare', test_config]
        main(args_list)

        # Test output
        config = tools.load_json(test_config)
        _verify_prepare_combos_output(config["scores_db"],
                                      config["emodels_hoc_dir"])
