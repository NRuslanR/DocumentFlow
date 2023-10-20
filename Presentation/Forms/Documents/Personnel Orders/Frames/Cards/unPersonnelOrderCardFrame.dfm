inherited PersonnelOrderCardFrame: TPersonnelOrderCardFrame
  Height = 424
  ExplicitHeight = 424
  inherited ScrollBox: TScrollBox
    Height = 424
    ExplicitHeight = 424
    inherited DocumentInfoPanel: TPanel
      Height = 424
      ExplicitHeight = 424
      inherited DocumentCardPageControl: TPageControl
        Height = 386
        ExplicitHeight = 386
        inherited DocumentMainInfoAndReceiversPage: TTabSheet
          ExplicitHeight = 358
          inherited SplitterBetweenMainInfoAndReceiversAreas: TSplitter
            Top = 167
            ExplicitTop = 167
          end
          inherited DocumentMainInfoArea: TPanel
            Height = 167
            ExplicitHeight = 167
            inherited DocumentMainInfoLabel: TLabel
              Width = 714
              Visible = False
            end
            inherited DocumentMainInfoFormArea: TPanel
              Height = 154
              ExplicitHeight = 154
            end
          end
          inherited DocumentChargesInfoArea: TPanel
            Top = 171
            Height = 187
            ExplicitTop = 171
            ExplicitHeight = 187
            inherited DocumentChargesLabel: TLabel
              Width = 714
            end
            inherited DocumentChargesFormArea: TPanel
              Height = 174
              ExplicitHeight = 174
            end
          end
        end
        inherited DocumentRelationsAndFilesPage: TTabSheet
          ExplicitHeight = 358
          inherited RelatedDocumentsAndFilesVerticalSplitter: TSplitter
            Height = 358
            ExplicitHeight = 358
          end
          inherited DocumentFilesViewArea: TPanel
            Height = 358
            ExplicitHeight = 358
            inherited DocumentFilesViewFormPanel: TPanel
              Height = 345
              ExplicitHeight = 345
            end
          end
          inherited RelatedDocumentsAndFilesPanel: TPanel
            Height = 358
            ExplicitHeight = 358
            inherited SplitterBetweenRelationsAndFilesAreas: TSplitter
              Top = 358
              Height = 358
              ExplicitTop = 358
              ExplicitHeight = 410
            end
            inherited DocumentRelationsInfoArea: TPanel
              Height = 358
              ExplicitHeight = 358
              inherited DocumentRelationsFormArea: TPanel
                Height = 345
                ExplicitHeight = 345
              end
            end
            inherited DocumentFilesInfoArea: TPanel
              Top = 716
              Height = 358
              ExplicitTop = 716
              ExplicitHeight = 358
              inherited DocumentFilesFormArea: TPanel
                Height = 345
                ExplicitHeight = 345
              end
            end
          end
        end
        inherited DocumentApprovingPage: TTabSheet
          ExplicitHeight = 358
          inherited DocumentApprovingsPagePanel: TPanel
            Height = 358
            ExplicitHeight = 358
          end
        end
        inherited DocumentPreviewPage: TTabSheet
          ExplicitHeight = 358
        end
        inherited DocumentMainInfoPage: TTabSheet
          ExplicitHeight = 358
        end
        inherited DocumentChargesPage: TTabSheet
          ExplicitHeight = 358
        end
      end
      inherited FooterButtonPanel: TPanel
        Top = 386
        ExplicitTop = 386
      end
    end
  end
end
