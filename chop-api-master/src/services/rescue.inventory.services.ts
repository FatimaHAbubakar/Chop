import { Inventory, PrismaClient, RescueInventory, Rescue, User } from '@prisma/client'
import RescueService from './rescue.services';
const prisma = new PrismaClient();

interface TRescueInventory extends RescueInventory{
    total: number,
    Rescue: Rescue & { Vendor: User; FII: User; },
    Inventory: Inventory
}

export default class CRescueInventory {
    static create = async (rescueInventory: any) => {

        try {
            const data = await prisma.rescueInventory.create({
                data: rescueInventory,
                include: {
                    Rescue: true
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static get = async () => {

        try {

            const data = await prisma.rescueInventory.findMany({
                include: {
                    Rescue: true
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static getById = async (id: number) => {

        try {

            const data = await prisma.rescueInventory.findFirst({
                where: {
                    id
                },
                include: {
                    Rescue: true
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static getByAllRescueId = async (id: number) => {

        try {

            const data = await prisma.rescueInventory.findMany({
                where: {
                    rescue_id: id
                },
                include: {
                    Inventory: true,
                    Rescue: {
                        include: {
                            Vendor: true,
                            FII: true,
                        }
                    },
                },
            });

            data.map((rescueInventory: TRescueInventory) => {

                // delete rescueInventory.createdAt;
                // delete rescueInventory.updatedAt;
                // delete rescueInventory.inventory_id;
                // delete rescueInventory.Inventory.createdAt;
                // delete rescueInventory.Inventory.updatedAt;
                delete rescueInventory.Rescue.FII.password;
                delete rescueInventory.Rescue.Vendor.password;

                let cost = rescueInventory.quantity * rescueInventory.Inventory.price;

                if (rescueInventory.Inventory.discount !== null) {

                    rescueInventory.total = cost - (cost * rescueInventory.Inventory.discount / 100);

                } else {

                    rescueInventory.total = cost;

                }

            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static getByRescueId = async (id: number) => {

        try {

            const data = await prisma.rescueInventory.findFirst({
                where: {
                    rescue_id: id
                },
                include: {
                    Rescue: true
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static getByVendorId = async (vendor_id: number) => {

        try {

            const rescuesByVendorId = await RescueService.getByVendorId(vendor_id);

            const promises = rescuesByVendorId.map((rescue) => {

                const rescueInventory = this.getByAllRescueId(rescue.id);

                return rescueInventory;

            });

            const data = await Promise.all(promises);

            return data.filter(arr => arr.length > 0);

        } catch (error) {

            console.log(error);

        }

    }

    static getByFiiId = async (fii_id: number) => {

        try {

            const rescuesByVendorId = await RescueService.getByFiiId(fii_id);

            const promises = rescuesByVendorId.map(async (rescue) => {

                const rescueInventory = await this.getByAllRescueId(rescue.id);

                return rescueInventory;

            });

            const data = await Promise.all(promises);

            return data.filter(arr => arr.length > 0);

        } catch (error) {

            console.log(error);

        }

    }

    static update = async (rescueInventory: any, id: number) => {

        try {

            const data = await prisma.rescueInventory.update({
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

        } catch (error) {

            console.log(error);

        }

    }

    static delete = async (id: number) => {

        try {

            const data = await prisma.rescueInventory.update({
                where: {
                    id
                },
                data: {
                    deleted: true
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }
}