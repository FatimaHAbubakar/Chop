"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var _a;
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
class UserNotification {
}
_a = UserNotification;
UserNotification.create = (userNotification) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.userNotification.create({
            data: userNotification
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
UserNotification.get = () => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.userNotification.findMany();
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
UserNotification.getById = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.userNotification.findFirst({
            where: {
                id
            }
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
UserNotification.getByNotificationId = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.userNotification.findFirst({
            where: {
                notification_id: id
            }
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
UserNotification.update = (userNotification, id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.userNotification.update({
            where: {
                id
            },
            data: userNotification
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
UserNotification.delete = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.userNotification.delete({
            where: {
                id
            },
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
exports.default = UserNotification;
//# sourceMappingURL=user.notification.services.js.map