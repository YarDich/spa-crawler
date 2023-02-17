import { Module } from "@nestjs/common";
import { RenderController } from "./controllers/render-controller/render.controller";
import { NestModule, MiddlewareConsumer } from "@nestjs/common";
import { RequestLoggerMiddleware } from "./middleware/RequestLoggerMiddleware";
import { MetricsController } from "./controllers/metrics/metrics.controller";
import { JsonLogger } from "./services/json-logger.service";

@Module({
    controllers: [RenderController, MetricsController],
    providers: [JsonLogger],
})
export class AppModule implements NestModule {
    configure(consumer: MiddlewareConsumer): void {
        consumer.apply(RequestLoggerMiddleware).forRoutes("*");
    }
}
