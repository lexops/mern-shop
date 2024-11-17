require("dotenv").config()
const express = require('express')
const cors = require('cors')
const morgan = require("morgan")
const cookieParser = require("cookie-parser")
const authRoutes = require("./routes/Auth")
const productRoutes = require("./routes/Product")
const orderRoutes = require("./routes/Order")
const cartRoutes = require("./routes/Cart")
const brandRoutes = require("./routes/Brand")
const categoryRoutes = require("./routes/Category")
const userRoutes = require("./routes/User")
const addressRoutes = require('./routes/Address')
const reviewRoutes = require("./routes/Review")
const wishlistRoutes = require("./routes/Wishlist")
const { connectToDB } = require("./database/db")

// server init
const server = express()
const apiRouter = express.Router();

// database connection
connectToDB()

// middlewares
server.use(cors({
    origin: process.env.ORIGIN,
    credentials: true,
    exposedHeaders: ['X-Total-Count'],
    methods: ['GET', 'POST', 'PATCH', 'DELETE'],
    maxAge: 0
}));
server.use(express.json())
server.use(cookieParser())
server.use(morgan("dev"))

// routeMiddleware added to apiRouter
apiRouter.use("/auth", authRoutes);
apiRouter.use("/users", userRoutes);
apiRouter.use("/products", productRoutes);
apiRouter.use("/orders", orderRoutes);
apiRouter.use("/cart", cartRoutes);
apiRouter.use("/brands", brandRoutes);
apiRouter.use("/categories", categoryRoutes);
apiRouter.use("/address", addressRoutes);
apiRouter.use("/reviews", reviewRoutes);
apiRouter.use("/wishlist", wishlistRoutes);

apiRouter.get("/healthz", (req, res) => {
    res.status(200).json({ message: 'running' });
});

server.use("/api", apiRouter);

server.listen(process.env.PORT || 8000, () => {
    console.log(`server [STARTED] ~ http://localhost:${process.env.PORT || 8000}`);
});

// light weight
