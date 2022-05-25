/// [enums] to define Internet connection status
enum ConnectionStatusEnum {
  internetConnectionAvailable,
  internetConnectionNotAvailable,
  loading,
}

/// [enums] to define [API] methods
enum ApiMethod { post, get, put, delete, patch }

/// [enums] to define [API] response status
enum ApiResponseStatus { idle, loading, completed, unProcessable, error }
