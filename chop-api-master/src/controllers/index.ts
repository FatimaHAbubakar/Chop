import { Router } from 'express';
import { Authenticate } from '../utils/auth.middleware';

import Auth from './auth.controller';
import Inventory from './inventory.controller';
import Fii from './fii.controller';
import Rescue from './rescue.controller';
import Review from './review.controller';
import Notification from './notification.controller';
import UserNotification from './user.notification.controller';
import RescueInventory from './rescue.inventory.controller';
import VerifyCode from './verify-code.controller';
import Vendor from './vendor.controller';

const router = Router();

router.use('/auth', Auth);
router.use('/inventory',Authenticate, Inventory);
router.use('/inventory-rescue',Authenticate, RescueInventory);
router.use('/fii',Authenticate, Fii);
router.use('/rescue',Authenticate, Rescue);
router.use('/review',Authenticate, Review);
router.use('/notification',Authenticate, Notification);
router.use('/user-notification',Authenticate, UserNotification);
router.use('/verify-code',Authenticate, VerifyCode);
router.use('/vendor',Authenticate, Vendor);


export default router;