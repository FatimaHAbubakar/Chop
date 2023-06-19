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
class Review {
}
_a = Review;
Review.create = (review) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.review.create({
            data: review
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Review.get = () => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.review.findMany();
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Review.getById = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.review.findFirst({
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
Review.getByVendorId = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.review.findMany({
            where: {
                vendor_id: id
            }
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Review.update = (review, id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.review.update({
            where: {
                id
            },
            data: review
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
Review.delete = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.review.delete({
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
exports.default = Review;
//# sourceMappingURL=review.services.js.map