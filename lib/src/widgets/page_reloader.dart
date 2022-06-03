/* Observer Pattern. 
 * This is the subject, to be received from upstream
 * in the widget tree.
 */
class PageReloadObserver {
  final _listeners = [];

  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  void notifyListeners() {
    for (final _listener in _listeners) {
      _listener.call();
    }
  }
}
