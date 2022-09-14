unit ApplicationService;

interface

uses

  IGetSelfUnit,
  SysUtils,
  Classes;

type

  TApplicationServiceException = class (Exception)

    private

      FInnerException: Exception;

      procedure SetInnerException(Value: Exception);

    protected

    public

      destructor Destroy; override;
      
      constructor Create(
        const Msg: String
      ); overload;

      constructor Create(
        const Msg: String;
        InnerException: Exception
      ); overload;

      constructor CreateFmt(
        const Msg: string;
        const Args: array of const
      ); overload;

      constructor CreateFmt(
        InnerException: Exception;
        const Msg: string;
        const Args: array of const
      ); overload;

      class procedure RaiseException(
        const Msg: String
      ); overload;

      class procedure RaiseException(
        const Msg: String;
        InnerException: Exception
      ); overload;
      
      class procedure RaiseException(
        const Msg: String;
        const Args: array of const
      ); overload;

      class procedure RaiseException(
        InnerException: Exception;
        const Msg: String;
        const Args: array of const
      ); overload;

    published

      property InnerException: Exception
      read FInnerException write SetInnerException;
      
  end;
  
  IApplicationService = interface (IGetSelf)
    ['{E697EF40-DB42-4875-A851-CBD083138A66}']
    
  end;
  
implementation

{ TApplicationServiceException }

constructor TApplicationServiceException.Create(
  const Msg: String
);
begin

  inherited Create(Msg);

end;

constructor TApplicationServiceException.CreateFmt(
  const Msg: string;
  const Args: array of const
);
begin

  inherited CreateFmt(Msg, Args);

end;

constructor TApplicationServiceException.CreateFmt(
  InnerException: Exception;
  const Msg: string;
  const Args: array of const
);
begin

  inherited CreateFmt(Msg, Args);

  FInnerException := InnerException;

end;

destructor TApplicationServiceException.Destroy;
begin

  FreeAndNil(FInnerException);
  inherited;

end;

class procedure TApplicationServiceException.RaiseException(
  const Msg: String;
  InnerException: Exception
);
begin

  raise TApplicationServiceException.Create(
    Msg,
    InnerException
  );
  
end;

class procedure TApplicationServiceException.RaiseException(
  InnerException: Exception;
  const Msg: String;
  const Args: array of const
);
begin

  raise TApplicationServiceException.CreateFmt(
    InnerException,
    Msg,
    Args
  );

end;

procedure TApplicationServiceException.SetInnerException(Value: Exception);
begin

  FreeAndNil(FInnerException);

  FInnerException := Value;
  
end;

class procedure TApplicationServiceException.RaiseException(const Msg: String);
begin

  raise TApplicationServiceException.Create(Msg);
  
end;

class procedure TApplicationServiceException.RaiseException(
  const Msg: String;
  const Args: array of const
);
begin

  raise TApplicationServiceException.CreateFmt(Msg, Args);
  
end;

constructor TApplicationServiceException.Create(const Msg: String;
  InnerException: Exception);
begin

  inherited Create(Msg);

  FInnerException := InnerException;
  
end;

end.
