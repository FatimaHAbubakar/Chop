const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

export const hashedPassword = async (password: string): Promise<string> => {

    try {

        const salt_round = 10;

        const salt = await bcrypt.genSalt(salt_round);

        const hash = await bcrypt.hash(password, salt);

        return hash;

    } catch (error) {

        console.log(error);

    }

}

export const checkPassword = async (password: string, hashedPassword: string) => {

    try {

        return await bcrypt.compare(password, hashedPassword);

    } catch (error) {

        console.log(error);

    }

}

export const generateToken = async (data: any) => {

    try {

        const token = jwt.sign({ data }, process.env.SECRET_KEY, { expiresIn: '30d' });

        return token;

    } catch (error) {

        console.log(error);

    }

}

export const verifyToken = async (token: string) => {

    try {

        const result = jwt.verify(token, process.env.SECRET_KEY);

        return result;

    } catch (error) {

        console.log(error);

    }

}