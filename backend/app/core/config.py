from pydantic import BaseModel


class Settings(BaseModel):
    app_name: str = "NextBid API"
    version: str = "0.1.0"
    mock_mode: bool = True  # flip to False once real parsers are wired


settings = Settings()
