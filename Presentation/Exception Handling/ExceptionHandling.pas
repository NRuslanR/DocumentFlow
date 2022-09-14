unit ExceptionHandling;

interface

implementation

uses

  madExcept,
  Windows,
  Forms,
  Dialogs,
  SysUtils,
  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit,
  ApplicationService,
  BusinessProcessService;

type

  TProgramExceptionHandler = class
      
    public

      procedure OnProgramExceptionOccurredEventHandler(
        const ExceptionInfo: IMEException;
        var Handled: Boolean
      );

  end;

var ApplicationExceptionHandler: TProgramExceptionHandler;

{ TProgramExceptionHandler }

procedure TProgramExceptionHandler.OnProgramExceptionOccurredEventHandler(
  const ExceptionInfo: IMEException;
  var Handled: Boolean
);
var ApplicationServiceException: TApplicationServiceException;
begin

    ExceptionInfo.TitleBar := '������';
    ExceptionInfo.CloseBtnVisible := False;
    ExceptionInfo.ExceptMsg := ExceptionInfo.ExceptMessage;

    ExceptionInfo.BugReportHeader['command line'] := '';

    { refactor }
    if not ExceptionInfo.ExceptObject.ClassType.InheritsFrom(
          TApplicationServiceException
       )
       or (
        Assigned(
          TApplicationServiceException(
            ExceptionInfo.ExceptObject
          ).InnerException
        )
        and not
          TApplicationServiceException(
            ExceptionInfo.ExceptObject
          ).InnerException.InheritsFrom(TApplicationServiceException)
       )
    then begin

      ExceptionInfo.MailSubject := '����� �� ������ � ���';

      ExceptionInfo.MailBody :=
          '����������, ���������� �� ������ ' +
          '��������� ������ � ����������� ������ ' +
          '������';
          
      ExceptionInfo.SendBoxTitle := '�������� ������ �� ������';

      ExceptionInfo.ShowBtnVisible := True;

    end

    else begin

      ExceptionInfo.SendBtnVisible := False;
      ExceptionInfo.ShowBtnVisible := False;
      
    end;

end;

initialization

  ApplicationExceptionHandler :=  TProgramExceptionHandler.Create;
  
  RegisterExceptionHandler(
    ApplicationExceptionHandler.OnProgramExceptionOccurredEventHandler,
    stDontSync
  );

end.
