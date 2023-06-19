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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
var _a;
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const rescue_services_1 = __importDefault(require("./rescue.services"));
const prisma = new client_1.PrismaClient();
class CRescueInventory {
}
_a = CRescueInventory;
CRescueInventory.create = (rescueInventory) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.rescueInventory.create({
            data: rescueInventory,
            include: {
                Rescue: true
            }
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
CRescueInventory.get = () => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.rescueInventory.findMany({
            include: {
                Rescue: true
            }
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
CRescueInventory.getById = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.rescueInventory.findFirst({
            where: {
                id
            },
            include: {
                Rescue: true
            }
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
CRescueInventory.getByAllRescueId = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.rescueInventory.findMany({
            where: {
                rescue_id: id
            },
            include: {
                Inventory: true,
                Rescue: true
            },
        });
        data.map((rescueInventory) => {
            // delete rescueInventory.createdAt;
            // delete rescueInventory.updatedAt;
            // delete rescueInventory.inventory_id;
            // delete rescueInventory.Inventory.createdAt;
            // delete rescueInventory.Inventory.updatedAt;
            let cost = rescueInventory.quantity * rescueInventory.Inventory.price;
            if (rescueInventory.Inventory.discount !== null) {
                rescueInventory.total = cost - (cost * rescueInventory.Inventory.discount / 100);
            }
            else {
                rescueInventory.total = cost;
            }
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
CRescueInventory.getByRescueId = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.rescueInventory.findFirst({
            where: {
                rescue_id: id
            },
            include: {
                Rescue: true
            }
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
CRescueInventory.getByVendorId = (vendor_id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const rescuesByVendorId = yield rescue_services_1.default.getByVendorId(vendor_id);
        const promises = rescuesByVendorId.map((rescue) => {
            const rescueInventory = _a.getByAllRescueId(rescue.id);
            return rescueInventory;
        });
        const data = yield Promise.all(promises);
        return data.filter(arr => arr.length > 0);
    }
    catch (error) {
        console.log(error);
    }
});
CRescueInventory.getByFiiId = (fii_id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const rescuesByVendorId = yield rescue_services_1.default.getByFiiId(fii_id);
        const promises = rescuesByVendorId.map((rescue) => __awaiter(void 0, void 0, void 0, function* () {
            const rescueInventory = yield _a.getByAllRescueId(rescue.id);
            return rescueInventory;
        }));
        const data = yield Promise.all(promises);
        return data.filter(arr => arr.length > 0);
    }
    catch (error) {
        console.log(error);
    }
});
CRescueInventory.update = (rescueInventory, id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.rescueInventory.update({
            where: {
                id
            },
            include: {
                Rescue: true,
                Inventory: true
            },
            data: rescueInventory
        });
        return data;
    }
    catch (error) {
        console.log(error);
    }
});
CRescueInventory.delete = (id) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const data = yield prisma.rescueInventory.delete({
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
exports.default = CRescueInventory;
//# sourceMappingURL=rescue.inventory.services.js.map