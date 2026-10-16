bool validateTextInput(String input, int length) {
  if (input == '') {
    return false;
  }
  if (input.trim() == '') {
    return false;
  }
  if (length > 0 && input.length <= length) {
    return true;
  }
  return false;
}
