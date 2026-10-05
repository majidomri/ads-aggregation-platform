from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas.user import UserCreate, UserLogin, UserOut
from app.services.user_service import UserService
from app.core.auth import get_current_user
from app.models.user import User

router = APIRouter(prefix="/auth", tags=["authentication"])

@router.post("/register", response_model=UserOut, status_code=status.HTTP_201_CREATED)
def register(user_create: UserCreate, db: Session = Depends(get_db)):
    user = UserService.create_user(db, user_create)
    return user

@router.post("/login")
def login(login_data: UserLogin, db: Session = Depends(get_db)):
    user = UserService.authenticate_user(db, login_data.email, login_data.password)
    tokens = UserService.create_tokens(user.id, user.email)
    return tokens

@router.post("/refresh")
def refresh_token(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    tokens = UserService.create_tokens(current_user.id, current_user.email)
    return tokens

@router.get("/me", response_model=UserOut)
def get_current_user_info(current_user: User = Depends(get_current_user)):
    return current_user
