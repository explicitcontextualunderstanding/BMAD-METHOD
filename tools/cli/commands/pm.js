const chalk = require('chalk');

module.exports = {
  command: 'pm',
  description: 'Run Party Mode - Multi-Agent Discussion',
  options: [],
  action: async () => {
    console.log(chalk.cyan('🎉 Party Mode Activated! 🎉'));
    console.log(chalk.dim('I will now orchestrate a group discussion with all available agents.'));
    console.log(chalk.dim('Please tell me what you would like to discuss with the team.'));
  },
};
