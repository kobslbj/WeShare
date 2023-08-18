const { getNumOfBuyers, getSeller } = require('../models/itemModel');
const orderModel = require('../models/orderModel');
const eventModel = require('../models/eventModel')

module.exports = {
    addOrder: async (req, res) => {
        const buyer_id = req.user.id;
        const item_id = parseInt(req.params.item_id);
        const get_seller = await getSeller(res, item_id);
        const seller_id = get_seller.seller_id;
        if(buyer_id === seller_id){
            return res.status(400).json({
                error: "Can't buy own product!"
            })
        }
        const result = await orderModel.addOrder(res, item_id, seller_id, buyer_id);
        const event = await eventModel.addEvent(res, item_id, '買家下單通知', buyer_id, seller_id);
        return res.status(200).json({ order: result });
    },
    agreeOrder: async (req, res) => {
        const seller_id = req.user.id;
        const order_id = parseInt(req.params.order_id);
        const IDs = await orderModel.getIDs(res, order_id);
        if( seller_id !== IDs.seller_id){
            return res.status(400).json({
                error: "Insufficient permissions!"
            })
        }
        const checkOrder = await getNumOfBuyers(res, IDs.item_id);
        if( checkOrder.num_of_buyers <= 0 ){
            return res.status(400).json({
                error: "Order limit exceeded!"
            })
        }
        const result = await orderModel.agreeOrder(res, order_id);
        const event = await eventModel.addEvent(res, IDs.item_id, '交易成功通知', seller_id, IDs.buyer_id);
        return res.status(200).json({ order: result });
    }
}