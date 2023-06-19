import { verifyToken } from "./jwt";

export const Authenticate = async (req: any, res: any, next: any) => {
    const authHeader = req.headers.authorization;

    if (authHeader) {

        const token = authHeader.split(' ')[1];

        const decode = await verifyToken(token);

        if (!decode) return res.sendStatus(403);

        next();

    } else {

        res.sendStatus(401);

    }

};