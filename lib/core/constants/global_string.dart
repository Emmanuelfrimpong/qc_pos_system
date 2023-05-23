final emailRegEx = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final List<String> newUserInfo = [
  'Make sure to provide accurate and up-to-date information about your company, including your business name, and contact details.',
  'All fields marked with * are required.',
  'Secret questions and answers are used to recover your password in case you forget it.',
  'If you need help or have any questions, don\'t hesitate to reach out to Quick Change POS customer support for assistance.',
];
final secretQuestion = [
  'What is your favorite childhood book?',
  'What is the name of the street you grew up on?',
  'What was your high school Nickname?',
  'What was the name of your first pet?',
  'What is your favorite movie or TV show?',
  'In what city or town was your mother born?'
];

// create 2 instructions fo login
final List<String> loginInfo = [
  'Please enter your UserID and password(Case sensitive) to login.',
  'Only administrator can reset using secret question and answer. Any other user should contact the administrator for password reset.',
  'If you need help or have any questions, don\'t hesitate to reach out to Quick Change POS customer support for assistance.',
];

final List<String> regions = [
  "Ashanti Region",
  "Bono Region",
  "Bono East Region",
  "Ahafo Region",
  "Central Region",
  "Eastern Region",
  "Greater Accra Region",
  "Northern Region",
  "North East Region",
  "Savannah Region",
  "Upper East Region",
  "Upper West Region",
  "Volta Region",
  "Oti Region",
  "Western Region",
  "Western North Region",
];

final List<String> namePrefix = ['Mr.', ' Mrs.', ' Ms.'];
final List<String> genders = ['Male', 'Female'];

final List<String> newUserInstruction = [
  'User password by default is 123456.',
  'User will be required to change password on first login.',
];
