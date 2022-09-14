unit BusinessProcessService;

interface

uses

  SysUtils,
  AbstractApplicationService,
  ApplicationService,
  Classes,
  Session;

type

  TBusinessProcessServiceException = class (TApplicationServiceException)

    private

      FBusinessOperationSuccessed: Boolean;

    public

      constructor Create(
        const BusinessOperationSuccessed: Boolean;
        const Msg: String
      );

      constructor CreateFmt(
        const BusinessOperationSuccessed: Boolean;
        const Msg: string;
        const Args: array of const
      );

      class procedure RaiseAsSuccessedBusinessProcessServiceException(
        const Msg: String
      ); overload;

      class procedure RaiseAsSuccessedBusinessProcessServiceException(
        const Msg: String;
        InnerException: Exception
      ); overload;

      class procedure RaiseAsSuccessedBusinessProcessServiceException(
        const Msg: String;
        const Args: array of const
      ); overload;

      class procedure RaiseAsSuccessedBusinessProcessServiceException(
        InnerException: Exception;
        const Msg: String;
        const Args: array of const
      ); overload;

      class procedure RaiseAsFailedBusinessProcessServiceException(
        const Msg: String
      ); overload;

      class procedure RaiseAsFailedBusinessProcessServiceException(
        const Msg: String;
        InnerException: Exception
      ); overload;

      class procedure RaiseAsFailedBusinessProcessServiceException(
        const Msg: String;
        const Args: array of const
      ); overload;

      class procedure RaiseAsFailedBusinessProcessServiceException(
        InnerException: Exception;
        const Msg: String;
        const Args: array of const
      ); overload;

      
    published

      property BusinessOperationSuccessed: Boolean
      read FBusinessOperationSuccessed;
      
  end;

  IBusinessProcessService = interface (IApplicationService)

  end;
  
  TBusinessProcessService = class abstract (
    TAbstractApplicationService,
    IBusinessProcessService
  )

    protected

      procedure RaiseSuccessedBusinessProcessServiceException(
        const ErrorMessage: String
      ); overload; virtual;

      procedure RaiseSuccessedBusinessProcessServiceException(
        const ErrorMessage: String;
        InnerException: Exception
      ); overload; virtual;
      
      procedure RaiseSucceesedBusinessProcessServiceException(
        const ErrorMessage: String;
        const Args: array of const
      ); overload; virtual;

      procedure RaiseSucceesedBusinessProcessServiceException(
        InnerException: Exception;
        const ErrorMessage: String;
        const Args: array of const
      ); overload; virtual;

      procedure RaiseFailedBusinessProcessServiceException(
        const ErrorMessage: String
      ); overload; virtual;

      procedure RaiseFailedBusinessProcessServiceException(
        const ErrorMessage: String;
        InnerException: Exception
      ); overload; virtual;
      
      procedure RaiseFailedBusinessProcessServiceException(
        const ErrorMessage: String;
        const Args: array of const
      ); overload; virtual;

      procedure RaiseFailedBusinessProcessServiceException(
        InnerException: Exception;
        const ErrorMessage: String;
        const Args: array of const
      ); overload; virtual;
      
    protected

      FSession: ISession;

      constructor Create(
        Session: ISession
      );

    public

  end;

implementation

{ TDocumentService }

constructor TBusinessProcessService.Create(Session: ISession);
begin

  inherited Create;

  FSession := Session;

end;

{ TBusinessProcessServiceException }

constructor TBusinessProcessServiceException.Create(
  const BusinessOperationSuccessed: Boolean;
  const Msg: String
);
begin

  inherited Create(Msg);

end;

constructor TBusinessProcessServiceException.CreateFmt(
  const BusinessOperationSuccessed: Boolean;
  const Msg: string;
  const Args: array of const
);
begin

  inherited CreateFmt(Msg, Args);

  FBusinessOperationSuccessed := BusinessOperationSuccessed;
  
end;

class procedure TBusinessProcessServiceException.
  RaiseAsFailedBusinessProcessServiceException(
    const Msg: String
  );
begin

  raise TBusinessProcessServiceException.Create(
    False,
    Msg
  );
  
end;

class procedure TBusinessProcessServiceException.
  RaiseAsFailedBusinessProcessServiceException(
    const Msg: String;
    const Args: array of const
  );
begin

  raise TBusinessProcessServiceException.CreateFmt(
    False,
    Msg,
    Args
  );

end;

class procedure TBusinessProcessServiceException.
  RaiseAsSuccessedBusinessProcessServiceException(
    const Msg: String
  );
begin

  raise TBusinessProcessServiceException.Create(
    True,
    Msg
  );
  
end;

class procedure TBusinessProcessServiceException.
  RaiseAsSuccessedBusinessProcessServiceException(
    const Msg: String;
    const Args: array of const
  );
begin

  raise TBusinessProcessServiceException.CreateFmt(
    True,
    Msg,
    Args
  );
  
end;

procedure TBusinessProcessService.
  RaiseFailedBusinessProcessServiceException(
    const ErrorMessage: String;
    const Args: array of const
  );
begin

  TBusinessProcessServiceException.
    RaiseAsFailedBusinessProcessServiceException(
      ErrorMessage,
      Args
    );

end;

procedure TBusinessProcessService.
  RaiseFailedBusinessProcessServiceException(
    const ErrorMessage: String
  );
begin

  TBusinessProcessServiceException.
    RaiseAsFailedBusinessProcessServiceException(
      ErrorMessage
    );

end;

procedure TBusinessProcessService.
  RaiseSucceesedBusinessProcessServiceException(
    const ErrorMessage: String;
    const Args: array of const
  );
begin

  TBusinessProcessServiceException.
    RaiseAsSuccessedBusinessProcessServiceException(
      ErrorMessage, Args
    );

end;

procedure TBusinessProcessService.
  RaiseSuccessedBusinessProcessServiceException(
    const ErrorMessage: String
  );
begin

  TBusinessProcessServiceException.
    RaiseAsSuccessedBusinessProcessServiceException(
      ErrorMessage
    );
    
end;

class procedure TBusinessProcessServiceException.
  RaiseAsFailedBusinessProcessServiceException(
    const Msg: String; InnerException: Exception);
var BusinessProcessServiceException: TBusinessProcessServiceException;
begin

  BusinessProcessServiceException :=
    TBusinessProcessServiceException.Create(False, Msg);

  BusinessProcessServiceException.InnerException := InnerException;

  raise BusinessProcessServiceException;
  
end;

class procedure TBusinessProcessServiceException.
  RaiseAsFailedBusinessProcessServiceException(
    InnerException: Exception;
    const Msg: String;
    const Args: array of const
  );
var BusinessProcessServiceException: TBusinessProcessServiceException;
begin

  BusinessProcessServiceException :=
    TBusinessProcessServiceException.CreateFmt(False, Msg, Args);

  BusinessProcessServiceException.InnerException := InnerException;

  raise BusinessProcessServiceException;

end;

class procedure TBusinessProcessServiceException.
  RaiseAsSuccessedBusinessProcessServiceException(
    const Msg: String;
    InnerException: Exception
  );
var BusinessProcessServiceException: TBusinessProcessServiceException;
begin

  BusinessProcessServiceException :=
    TBusinessProcessServiceException.Create(True, Msg);

  BusinessProcessServiceException.InnerException := InnerException;

  raise BusinessProcessServiceException;

end;

class procedure TBusinessProcessServiceException.
  RaiseAsSuccessedBusinessProcessServiceException(
    InnerException: Exception;
    const Msg: String;
    const Args: array of const
  );
var BusinessProcessServiceException: TBusinessProcessServiceException;
begin

  BusinessProcessServiceException :=
    TBusinessProcessServiceException.CreateFmt(True, Msg, Args);

  BusinessProcessServiceException.InnerException := InnerException;

  raise BusinessProcessServiceException;

end;

procedure TBusinessProcessService.
  RaiseFailedBusinessProcessServiceException(
    InnerException: Exception;
    const ErrorMessage: String;
    const Args: array of const
  );
begin

  TBusinessProcessServiceException.
    RaiseAsFailedBusinessProcessServiceException(
      InnerException, ErrorMessage, Args
    );

end;

procedure TBusinessProcessService.
  RaiseFailedBusinessProcessServiceException(
    const ErrorMessage: String;
    InnerException: Exception
  );
begin

  TBusinessProcessServiceException.
    RaiseAsFailedBusinessProcessServiceException(
      ErrorMessage, InnerException
    );
  
end;

procedure TBusinessProcessService.
  RaiseSucceesedBusinessProcessServiceException(
    InnerException: Exception;
    const ErrorMessage: String;
    const Args: array of const
  );
begin

  TBusinessProcessServiceException.
    RaiseAsSuccessedBusinessProcessServiceException(
      InnerException, ErrorMessage, Args
    );
    
end;

procedure TBusinessProcessService.
  RaiseSuccessedBusinessProcessServiceException(
    const ErrorMessage:
    String; InnerException: Exception
  );
begin

  TBusinessProcessServiceException.
    RaiseAsSuccessedBusinessProcessServiceException(
      ErrorMessage, InnerException
    );

end;

end.
