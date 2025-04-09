import logging
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy"})

@app.route('/multiply', methods=['POST'])
def multiply():
    data = request.get_json()
    
    if not data or 'a' not in data or 'b' not in data:
        return jsonify({"error": "Missing required parameters: a, b"}), 400
    
    try:
        a = float(data['a'])
        b = float(data['b'])
        result = a * b
        
        logger.info(f"Multiplication: {a} * {b} = {result}")
        
        return jsonify({"result": result})
    except ValueError as e:
        return jsonify({"error": str(e)}), 400

if __name__ == '__main__':
    logger.info("Multiplication Service starting on port 8003")
    app.run(host='0.0.0.0', port=8003)