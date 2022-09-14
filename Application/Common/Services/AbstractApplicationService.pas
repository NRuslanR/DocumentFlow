unit AbstractApplicationService;

interface

uses

  ApplicationService,
  SysUtils,
  Classes;

type

  TAbstractApplicationService = class (TInterfacedObject, IApplicationService)

    protected

      procedure RaiseApplicationServiceException(
        const ErrorMessage: String
      ); overload; virtual;

      procedure RaiseApplicationServiceException(
        const ErrorMessage: String;
        const Args: array of const
      ); overload; virtual;

    function GetSelf: TObject;

  end;
  
implementation

{ TAbstractApplicationService }

function TAbstractApplicationService.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TAbstractApplicationService.
  RaiseApplicationServiceException(
    const ErrorMessage: String
  );
begin

  raise
  TApplicationServiceException.Create(
    ErrorMessage
  );

end;

procedure TAbstractApplicationService.RaiseApplicationServiceException(
  const ErrorMessage: String; const Args: array of const);
begin

  TApplicationServiceException.RaiseException(ErrorMessage, Args);
  
end;

end.
