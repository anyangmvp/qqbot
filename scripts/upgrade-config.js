const fs = require('fs');

const configFile = process.argv[2];
const config = JSON.parse(fs.readFileSync(configFile, 'utf8'));

if (config.channels && config.channels.qqbot) {
    delete config.channels.qqbot;
    console.log('  - 已删除 channels.qqbot');
}

if (config.plugins && config.plugins.entries && config.plugins.entries.qqbot) {
    delete config.plugins.entries.qqbot;
    console.log('  - 已删除 plugins.entries.qqbot');
}

if (config.plugins && config.plugins.installs && config.plugins.installs.qqbot) {
    delete config.plugins.installs.qqbot;
    console.log('  - 已删除 plugins.installs.qqbot');
}

if (config.plugins && config.plugins.allow && Array.isArray(config.plugins.allow)) {
    const index = config.plugins.allow.indexOf('qqbot');
    if (index !== -1) {
        config.plugins.allow.splice(index, 1);
        console.log('  - 已从 plugins.allow 数组中删除 qqbot');
    }
}

fs.writeFileSync(configFile, JSON.stringify(config, null, 2));
console.log('配置文件已更新');
