{
  Refactor:
  �������� �������� � �������
  �������� ������� � ���������� �������
  �� DTO-������� ��� ����������
  ����������� �� ����������� ������ ���
  ����������� ����
}
unit DocumentChargeSheetCasesNotifier;

interface

uses

  DocumentChargeSheet,
  ApplicationService,
  Employee,
  SysUtils,
  Classes;

type

  TDocumentChargeSheetsNotificationCase = (
    NewDocumentChargeSheetsCreatedCase,
    DocumentChargeSheetsChangedCase,
    DocumentChargeSheetsRemovedCase
  );

  TOnDocumentChargeSheetNotificationSentEventHandler =
    procedure (
      Sender: TObject;
      DocumentChargeSheetNotificationCase: TDocumentChargeSheetsNotificationCase
    ) of object;

  TOnDocumentChargeSheetNotificationSendingFailedEventHandler =
    procedure (
      Sender: TObject;
      const Error: Exception;
      DocumentChargeSheetNotificationCase: TDocumentChargeSheetsNotificationCase
    ) of object;

  TDocumentChargeSheetCasesNotifierException = class (TApplicationServiceException)

  end;

  IDocumentChargeSheetCasesNotifier = interface (IApplicationService)

    procedure SendNotificationAboutDocumentChargeSheets(
      DocumentChargeSheets: TDocumentChargeSheets;
      NotificationSender: TEmployee;
      DocumentChargeSheetsNotificationCase: TDocumentChargeSheetsNotificationCase
    );

    procedure SendNotificationAboutDocumentChargeSheetsAsync(

      DocumentChargeSheets: TDocumentChargeSheets;
      NotificationSender: TEmployee;
      DocumentChargeSheetsNotificationCase: TDocumentChargeSheetsNotificationCase;

      OnDocumentChargeSheetNotificationSentEventHandler:
        TOnDocumentChargeSheetNotificationSentEventHandler;

      OnDocumentChargeSheetNotificationSendingFailedEventHandler:
        TOnDocumentChargeSheetNotificationSendingFailedEventHandler

    );

  end;

implementation

end.
