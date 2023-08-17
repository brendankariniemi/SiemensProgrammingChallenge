import 'package:gsheets/gsheets.dart';

class GoogleSheetsAPI {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "siemensintern",
  "private_key_id": "60974358465bdd55bc16f8a298fc298b532440e6",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC8K300d1mzM+ew\n1WjTBP/c/ZxGlHnDJVquTEMF1c6BHiQjrV/2gbr0dJ1pqLjp10zEfmYkL8L+ADK2\nK3soYhZiSdGc42jF1dcM+I1EVRomLZh+T4P4xgjmMdO0vXK4ZjrU5WG9RgLyjxYq\niUFT+++xhUmAHuvwb+KOz8pJEGI9dFZ6sypCjjIWbL5ELoKcH3v+cy3MgsJmIZKn\nxHCsHP6hG9XR9Id85+ngMKp06zm4ZFtwykoLkjdHYladML9a8zW+3zWHGYOEu5rM\n/9fwkXBhW2KIpQLiw5Ak8qtCMqY6PGHJAQ8uC0h9H7XYcq/rf4lMy1hBUWK19a5S\nQGYSOqKLAgMBAAECggEAS8OI7JyXkdd21NUAmWJ8cOruRt7WbfP24JIVNF7DgGp1\n66WNq2/Nqkrf7KCCH6lQIBeyoaRXczT6Ni4orvhbgeSuEOjhkTKKHY9gNeC8IB4g\ntc7nWL3H7IOodbAH5mZHDtxy76YmXqqtJqBQHPQmLQh5MSyCHDO4eX8BuExv+cTQ\nyQhy1BGVPj/y1HNh+XkgtsWGzKYXI6Zdk2+B7bOXs3AuYnY1rYK8pfu5VPHMII/1\nSTOe87ZR/EtyhCYI0YRK46rmGxAZcrGE3uFXQapY4i4n5n5ZHIs9+yiHrUy23yuB\nB87TI4/0XEHGGWkiQVj8suIeItpJ5bGW4X2U8rNt6QKBgQD9s1AE9Hh62RxSy2tq\nRJai9+3MPkFzmTrxAXJmkmhSV7zj642QmodzflKproQ4phhCm9TtuHesUP+sflcO\nFIu48tUOIHkrEY6+6AMRvOiSudUUeewhiOs8CehzdxGwK9Pl/A9aeR6NXG4mSCJc\nYSJZnVWPkVFO/mux6y/8Ot9zAwKBgQC94B6A76VUcL7ABFibSkk81gy3mhyKe2me\nqJ+v7ps6C6kOj9gMn5PYYCpywwtbkG0rzT3jVopNi6s6rX8um+hsE6df8mKUlQsw\nZqMU+npEzRfy569/ctynuq3U4MOo2Pajfw+5GQjE7JrHL5PFHermwo806eAuQraB\ndXEzoYm32QKBgQCuT9bKIMLq/WOVi4jZMhkiDiFINPo5l+3Ei87zpOKiuP/ixgS1\nd0db1k6roWndllmS4okRcK5hKiIRfZkI5pr9z3MNysgWDHE8wCLjvB08Owypjf/t\nJqshzFj3hLcViXeFTIOsEQ4p6HkSOnvJZz/3vL997kWkdfC/BS4qKrU+ywKBgBgx\nG/HVlr0BeGxCoX93oYksxIYIDqbePoDGf0INJp3oqmt+jEpfcpjY98+TZjkOV7qC\n9eWnOwvSRci+Hjw0BRLwFh01ZrYDn19VVGXx2+40K175gfS9D7wXHtrGoGc87X+7\nSqeMtv9QHhBO0YcF3s3z8AcP3U5HlbU832VyqXdRAoGBAMmh8XAjp2RnWgRMPO96\nmcslsHhi7LgeYIJ0b6Hui7dxBoohUWPqYd7sSgQB6lPU9SvCeOL5H5Jg2vFB+5W4\nL2uyQ01nXZ3VvhO2BA8eHeBdhB6ViW7o7K4QXtKXZBnJ0TroyVoXjWXxJatFIflZ\npjzXQC2tsAawz7jhdFsbsj0o\n-----END PRIVATE KEY-----\n",
  "client_email": "fluttergsheets@siemensintern.iam.gserviceaccount.com",
  "client_id": "109914238428815974342",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/fluttergsheets%40siemensintern.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
  }
  
  ''';
  static final _spreadsheetID = '1GxgN0Muy7vof1PNY-TLbjIRSINZtA68jvP9iwpNrUeQ';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetID);
    _worksheet = ss.worksheetByTitle('Sheet1');
  }

  Future<List<List<String>>?> getData() async {
    final values = await _worksheet?.values.allRows(fromRow:2, fromColumn: 1);
    return values;
  }
}