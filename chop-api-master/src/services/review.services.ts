import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient();

export default class Review {

    static create = async (review: any) => {

        try {
            const data = await prisma.review.create({
                data: review
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static get = async () => {

        try {

            const data = await prisma.review.findMany();

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static getById = async (id: number) => {

        try {

            const data = await prisma.review.findFirst({
                where: {
                    id
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static getByVendorId = async (id: number) => {

        try {

            const data = await prisma.review.findMany({
                where: {
                    vendor_id: id
                }
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static update = async (review: any, id: number) => {

        try {

            const data = await prisma.review.update({
                where: {
                    id
                },
                data: review
            });

            return data;

        } catch (error) {

            console.log(error);

        }

    }

    static delete = async (id: number) => {

        try {

            const data = await prisma.review.update({
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