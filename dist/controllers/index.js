"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_middleware_1 = require("../utils/auth.middleware");
const auth_controller_1 = __importDefault(require("./auth.controller"));
const inventory_controller_1 = __importDefault(require("./inventory.controller"));
const rescue_controller_1 = __importDefault(require("./rescue.controller"));
const review_controller_1 = __importDefault(require("./review.controller"));
const notification_controller_1 = __importDefault(require("./notification.controller"));
const user_notification_controller_1 = __importDefault(require("./user.notification.controller"));
const rescue_inventory_controller_1 = __importDefault(require("./rescue.inventory.controller"));
const verify_code_controller_1 = __importDefault(require("./verify-code.controller"));
const vendor_controller_1 = __importDefault(require("./vendor.controller"));
const router = (0, express_1.Router)();
router.use('/auth', auth_controller_1.default);
router.use('/inventory', auth_middleware_1.Authenticate, inventory_controller_1.default);
router.use('/inventory-rescue', auth_middleware_1.Authenticate, rescue_inventory_controller_1.default);
router.use('/rescue', auth_middleware_1.Authenticate, rescue_controller_1.default);
router.use('/review', auth_middleware_1.Authenticate, review_controller_1.default);
router.use('/notification', auth_middleware_1.Authenticate, notification_controller_1.default);
router.use('/user-notification', auth_middleware_1.Authenticate, user_notification_controller_1.default);
router.use('/verify-code', auth_middleware_1.Authenticate, verify_code_controller_1.default);
router.use('/vendor', auth_middleware_1.Authenticate, vendor_controller_1.default);
exports.default = router;
//# sourceMappingURL=index.js.map