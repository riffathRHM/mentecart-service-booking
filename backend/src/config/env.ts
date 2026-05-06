import { z } from 'zod';
import type { StringValue } from 'ms';
import dotenv from "dotenv";

dotenv.config();

const envSchema = z.object({
  NODE_ENV: z
    .enum(["development", "production", "test"])
    .default("development"),
  PORT: z
    .string()
    .default("3000")
    .transform(Number)
    .pipe(z.number().int().positive()),
  LOG_LEVEL: z
    .enum(["trace", "debug", "info", "warn", "error", "fatal"])
    .default("info"),

  MONGO_URI: z.string().url("Invalid MongoDB URI"),

  JWT_SECRET: z.string().min(32, "JWT_SECRET must be at least 32 characters"),
 JWT_EXPIRY: z.string().default('24h') as z.ZodType<StringValue>,
JWT_REFRESH_EXPIRY: z.string().default('7d') as z.ZodType<StringValue>,
  JWT_REFRESH_SECRET: z
    .string()
    .min(32, "JWT_REFRESH_SECRET must be at least 32 characters")
    .optional(),
  

  PAYHERE_MERCHANT_ID: z.string().optional(),
  PAYHERE_SECRET_KEY: z.string().optional(),
  PAYHERE_ENV: z.enum(["sandbox", "live"]).default("sandbox").optional(),

  CART_EXPIRY_MINUTES: z
    .string()
    .default("15")
    .transform(Number)
    .pipe(z.number().positive()),
  MAX_BOOKINGS_PER_DAY: z
    .string()
    .default("3")
    .transform(Number)
    .pipe(z.number().positive()),
  BOOKING_CANCELLATION_CUTOFF_HOURS: z
    .string()
    .default("2")
    .transform(Number)
    .pipe(z.number().positive()),

  CORS_ORIGIN: z.string().default("http://localhost:5000"),

  SMTP_HOST: z.string().optional(),
  SMTP_PORT: z.string().optional(),
  SMTP_USER: z.string().optional(),
  SMTP_PASS: z.string().optional(),
});

type EnvConfig = z.infer<typeof envSchema>;

let config: EnvConfig;

try {
  config = envSchema.parse(process.env);
} catch (error) {
  if (error instanceof z.ZodError) {
    const messages = error.issues
      .map((err) => `${err.path.join(".")}: ${err.message}`)
      .join("\n");

    console.error("Environment validation failed:\n", messages);
    process.exit(1);
  }
  throw error;
}

export default config;
