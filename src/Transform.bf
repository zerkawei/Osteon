using System;
using System.Collections;
namespace Osteon;

public class Transform2D
{
	private bool              mDirty;
	private Vector2           mScale; 
	private Vector2           mTranslation;
	private float             mRotation;
	private Matrix3           mTransform;
	private CompactList<Self> mChildren = .() ~ _.Dispose();
	private Self              mParent;

	public bool HasChanged
	{
		get => mDirty;
		set
		{
			mDirty = value;
			if(mDirty)
			{
				for(let t in mChildren) { t.HasChanged = true; }
			}
		}
	}
	public Vector2 Scale
	{
		get => mScale;
		set
		{
			if(mScale != value)
			{
				mScale = value;
				mDirty = true;
			}
		}
	}
	public Vector2 WorldPosition => (.)LocalToWorld[2];
	public Vector2 Position
	{
		get => mTranslation;
		set
		{
			if(mTranslation != value)
			{
				mTranslation = value;
				mDirty = true;
			}
		}
	}
	public float Rotation
	{
		get => mRotation;
		set
		{
			if(mRotation != value)
			{
				mRotation = value;
				mDirty = true;
			}
		}
	}
	public Matrix3 LocalToWorld
	{
		get
		{
			if(mDirty)
			{
				let s = Math.Sin(mRotation);
				let c = Math.Cos(mRotation) * mScale;
				mTransform = .(
					c.X, -s, mTranslation.X,
					s,  c.Y, mTranslation.Y,
					0,  0,   1);
				if(mParent != null)
				{
					mTransform = mTransform * mParent.LocalToWorld;
				}
				mDirty = false;
			}	
			return mTransform;
		}
	}
	public Self Parent
	{
		get => mParent;
		set
		{
			if(mParent != null)
			{
				mParent.mChildren.Remove(this);
			}
			mParent = value;
			mParent.mChildren.Add(this);
		}
	}


	public this(Vector2 scale = .One, float rotation = 0 , Vector2 translation = .Zero, Self parent = null)
	{
		mScale       = scale;
		mRotation    = rotation;
		mTranslation = translation;
		mParent      = parent;
	}
}

public class Transform
{
	private bool              mDirty;
	private Vector3           mScale; 
	private Vector3           mTranslation;
	private Quaternion        mRotation;
	private Matrix4           mTransform;
	private CompactList<Self> mChildren = .() ~ _.Dispose();
	private Self              mParent;

	public bool HasChanged
	{
		get => mDirty;
		set
		{
			mDirty = value;
			if(mDirty)
			{
				for(let t in mChildren) { t.HasChanged = true; }
			}
		}
	}
	public Vector3 Scale
	{
		get => mScale;
		set
		{
			if(mScale != value)
			{
				mScale = value;
				mDirty = true;
			}
		}
	}
	public Vector3 WorldPosition => (.)LocalToWorld[2];
	public Vector3 Position
	{
		get => mTranslation;
		set
		{
			if(mTranslation != value)
			{
				mTranslation = value;
				mDirty = true;
			}
		}
	}
	public Quaternion Rotation
	{
		get => mRotation;
		set
		{
			if(mRotation != value)
			{
				mRotation = value;
				mDirty = true;
			}
		}
	}
	public Matrix4 LocalToWorld
	{
		get
		{
			if(mDirty)
			{
				mTransform      = mRotation;
				mTransform[3]   = mTranslation;
 				mTransform[0,0] *= mScale.X;
				mTransform[1,1] *= mScale.Y;
				mTransform[2,2] *= mScale.Z;
				if(mParent != null)
				{
					mTransform = mTransform * mParent.LocalToWorld;
				}
				mDirty = false;
			}	
			return mTransform;
		}
	}
	public Self Parent
	{
		get => mParent;
		set
		{
			if(mParent != null)
			{
				mParent.mChildren.Remove(this);
			}
			mParent = value;
			mParent.mChildren.Add(this);
		}
	}

	public this(Vector3 scale = .One, Quaternion rotation = .Identity, Vector3 translation = .Zero, Self parent = null)
	{
		mScale       = scale;
		mRotation    = rotation;
		mTranslation = translation;
		mParent      = parent;
	}
}