export class AppError extends Error {
  constructor(
    public statusCode: number,
    public message: string,
    public errorCode?: string
  ) {
    super(message);
    Object.setPrototypeOf(this, AppError.prototype);
  }
}

export class ValidationError extends AppError {
  constructor(message: string, errorCode = 'VALIDATION_ERROR') {
    super(400, message, errorCode);
    Object.setPrototypeOf(this, ValidationError.prototype);
  }
}

export class AuthenticationError extends AppError {
  constructor(message = 'Authentication failed', errorCode = 'AUTH_FAILED') {
    super(401, message, errorCode);
    Object.setPrototypeOf(this, AuthenticationError.prototype);
  }
}

export class AuthorizationError extends AppError {
  constructor(message = 'Insufficient permissions', errorCode = 'FORBIDDEN') {
    super(403, message, errorCode);
    Object.setPrototypeOf(this, AuthorizationError.prototype);
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string, errorCode = 'NOT_FOUND') {
    super(404, `${resource} not found`, errorCode);
    Object.setPrototypeOf(this, NotFoundError.prototype);
  }
}

export class ConflictError extends AppError {
  constructor(message: string, errorCode = 'CONFLICT') {
    super(409, message, errorCode);
    Object.setPrototypeOf(this, ConflictError.prototype);
  }
}

export class InternalServerError extends AppError {
  constructor(message = 'Internal server error', errorCode = 'INTERNAL_ERROR') {
    super(500, message, errorCode);
    Object.setPrototypeOf(this, InternalServerError.prototype);
  }
}