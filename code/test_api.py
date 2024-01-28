from fastapi.testclient import TestClient
from main import app  # replace 'your_app_filename' with the name of the file containing your FastAPI app

client = TestClient(app)

def test_read_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Hello World", "number": "+234000333888"}
