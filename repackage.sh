#!/usr/bin/env node

/**
 * The following script will create a new Vagrant "base box" that is based off of the Vagrant box
 * defined within this folder.
 *
 * To run it, just call the script: $ ./repackage.sh
 */

var fs = require('fs'),
    json,
    configFile = __dirname + '/config.json',
    runCommand,
    newBoxName = process.argv[2] || null,
    newBoxPath;

if (!newBoxName) {
    console.log('You must specify a filename for the new base box to be generated. For example: $ ./repackage.sh new_box.box');
    process.exit(1);
}

newBoxPath = __dirname + '/' + newBoxName;

runCommand = function(cmd, args, cb, fin) {
    var spawn = require('child_process').spawn,
        child = spawn(cmd, args),
        me = this,
        all = null;
    child.stdout.setEncoding('utf8');
    child.stdout.on('data', function (buffer) {
        if (!all) {
            all = buffer;
        } else {
            all += buffer;
        }
        if (typeof cb === 'function') {
            cb(me, buffer)
        }
    });
    if (typeof fin === 'function') {
        child.stdout.on('end', function() {
            fin(all);
        });
    }
}

json = fs.readFileSync(configFile, 'utf8');
try {
    json = JSON.parse(json);
} catch(e) {
    throw 'Error: Unable to read configuration file: ' + configFile;
}

if (!json.id) {
    throw 'Error: No value specified for `id`.';
}

console.log('A new Vagrant "base box" is being created: ' + newBoxPath);
console.log('This might take a minute...');

runCommand('vagrant', [
    'package',
    '--base',
    json.id,
    '--output',
    newBoxPath
], function(fn, data) {
    console.log(data);
}, function(data) {
    process.exit(0);
});
