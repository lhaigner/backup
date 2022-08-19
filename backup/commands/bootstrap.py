import os
import subprocess

def on_bootstrap(config, args):
    processes = []

    for repository in config['repositories']:
        process = create_init_process(config, repository)
        processes.append(process)

    results = [ process.wait() for process in processes ]
    print(results)

def create_init_process(config, repository):
    env = os.environ.copy()
    env['BORG_PASSPHRASE'] = config['passphrase']
    env['BORG_REPO'] = repository['url']
    return subprocess.Popen(['borg', 'init', '--encryption=repokey-blake2'] + repository.get('options', []), env=env)
