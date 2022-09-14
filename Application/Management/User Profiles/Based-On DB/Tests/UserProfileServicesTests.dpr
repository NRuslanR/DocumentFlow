program UserProfileServicesTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options 
  to use the console test runner.  Otherwise the GUI test runner will be used by 
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  TestBasedOnDatabaseUserNotificationProfileService_Zeos in 'TestBasedOnDatabaseUserNotificationProfileService_Zeos.pas',
  BasedOnDatabaseUserNotificationProfileService in '..\BasedOnDatabaseUserNotificationProfileService.pas',
  UserNotificationProfile in '..\..\Dtos\UserNotificationProfile.pas',
  UserNotificationProfileService in '..\..\Interfaces\UserNotificationProfileService.pas',
  NativeDocumentKindDto in '..\..\..\..\Presentation\Docs\References\Document Kinds\DTOs\NativeDocumentKindDto.pas',
  DocumentKindDto in '..\..\..\..\Presentation\Docs\References\Document Kinds\DTOs\DocumentKindDto.pas',
  DocumentKinds in '..\..\..\..\Common\DocumentKinds.pas',
  PathBuilder in 'D:\Common Delphi Libs\u_59968 Delphi Modules\File Storage Service Project\PathBuilder.pas',
  LocalNetworkFileStorageServiceClientUnit in 'D:\Common Delphi Libs\u_59968 Delphi Modules\File Storage Service Project\LocalNetworkFileStorageServiceClientUnit.pas',
  DatabaseTransaction in 'D:\Common Delphi Libs\u_59968 Delphi Modules\Repositories and Domain\Session\New\DatabaseTransaction.pas',
  PostgresTransaction in 'D:\Common Delphi Libs\u_59968 Delphi Modules\Repositories and Domain\Session\New\PostgresTransaction.pas',
  Session in 'D:\Common Delphi Libs\u_59968 Delphi Modules\Repositories and Domain\Session\New\Session.pas',
  StubSession in 'D:\Common Delphi Libs\u_59968 Delphi Modules\Repositories and Domain\Session\New\StubSession.pas',
  DataSetDataReader in 'D:\Common Delphi Libs\u_59968 Delphi Modules\Query Executors\DataSet-Based Executors\DataSetDataReader.pas';

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.

