
extension StringExtenstion on String {
  int get firstNumber {

    for (int i = 0; i < this.length; i++){
      if (int.tryParse(this[i]) != null) return int.parse(this[i]);
    }
    return null;
  }
}