from datetime import datetime, timedelta
from fastapi import Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.user import User
from app.models.advertiser import Advertiser
from app.schemas.user import UserCreate, TokenResponse
from app.core.security import SecurityUtils

class UserService:
    @staticmethod
    def create_user(db: Session, user_create: UserCreate) -> User:
        # Check if user already exists
        existing_user = db.query(User).filter(
            (User.email == user_create.email) | (User.username == user_create.username)
        ).first()
        
        if existing_user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email or username already registered"
            )
        
        hashed_password = SecurityUtils.hash_password(user_create.password)
        db_user = User(
            username=user_create.username,
            email=user_create.email,
            full_name=user_create.full_name,
            password_hash=hashed_password,
            role=user_create.role,
            created_at=datetime.utcnow(),
            updated_at=datetime.utcnow()
        )
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        return db_user

    @staticmethod
    def authenticate_user(db: Session, email: str, password: str) -> User:
        user = db.query(User).filter(User.email == email).first()
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid email or password"
            )
        
        if not SecurityUtils.verify_password(password, user.password_hash):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid email or password"
            )
        
        if not user.is_active:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="User account is inactive"
            )
        
        user.last_login = datetime.utcnow()
        db.commit()
        
        return user

    @staticmethod
    def create_tokens(user_id: int, email: str) -> TokenResponse:
        access_token_expires = timedelta(minutes=30)  # short-lived
        access_token = SecurityUtils.create_access_token(
            data={"sub": user_id, "email": email},
            expires_delta=access_token_expires
        )
        
        refresh_token = SecurityUtils.create_refresh_token(
            data={"sub": user_id, "email": email}
        )
        
        return TokenResponse(
            access_token=access_token,
            refresh_token=refresh_token,
            expires_in=30 * 60  # seconds
        )
